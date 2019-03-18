def format_list(list_, *suffix):
  sl = list(suffix)
  return [''.join([it] + sl) for it in list_]

class FilterModule(object):
  def filters(self):
    return {
      'suffix': format_list,
    }