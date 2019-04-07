#! /usr/bin/env python2

import argparse
from datetime import datetime, timedelta
import requests
import sys

parser = argparse.ArgumentParser()
parser.add_argument('--days', help='days since last contact before pruning', default=7, type=int)
parser.add_argument('--token', help='gitlab personal token with API scope')
parser.add_argument('--url', help='gitlab base URL')

def main(url, token, days):
  headers = {'Private-Token': token}

  now = datetime.now()
  threshold = now - timedelta(days)

  runners = requests.get('https://%s/api/v4/runners/all?per_page=100' % url, headers=headers).json()
  for r in runners:
    id = r.get('id')
    name = r.get('name')
    title = 'runner %s (%s)' % (id, name)

    details = requests.get('https://%s/api/v4/runners/%d' % (url, id), headers=headers).json()
    contacted = details.get('contacted_at')

    if contacted == None:
      print('removing %s, runner has never been contacted' % title)
      requests.delete('https://%s/api/v4/runners/%d' % (url, id), headers=headers)
      continue

    last_contact = datetime.strptime(contacted, '%Y-%m-%dT%H:%M:%S.%fZ')
    contact_delta = now - last_contact
    print('%s was last contacted %s days ago' % (title, contact_delta.days))

    if last_contact < threshold:
      print('removing %s, contact was before threshold' % title)
      requests.delete('https://%s/api/v4/runners/%d' % (url, id), headers=headers)
      continue

    print('keeping %s' % title)

if __name__ == '__main__':
  args = parser.parse_args()
  main(args.url, args.token, args.days)