
from ansible.plugins.action import ActionBase
import os
import tempfile

try:
    from __main__ import display
except ImportError:
    from ansible.utils.display import Display
    display = Display()

class ActionModule(ActionBase):
    def run(self, tmp=None, task_vars=None):
        if task_vars is None:
            task_vars = dict()

        self._supports_check_mode = True
        self._supports_async = True

        # we must use vars, since task_vars will have un-processed variables
        command = self._task.args.get('command', 'apply')
        content = self._task.args.get('content', '')
        file = self._task.args.get('file', '-')

        if content is not '':
            with tempfile.NamedTemporaryFile(delete=False) as content_file:
                content_file.write(content)
                content_file.flush()
                return self.execute_file(command, content_file.name, tmp, task_vars)
        elif file is not '-':
            return self.execute_file(command, file, tmp, task_vars)
        else:
            return self.execute_command(command, tmp, task_vars)

    def get_args(self, command):
        argv=['kubectl']

        if type(command) == list:
            argv.extend(command)
        else:
            argv.append(command)

        if self._play_context.check_mode:
            argv.append('--dry-run')

        if 'namespace' in self._task.args:
            argv.extend([
                '-n',
                self._task.args.get('namespace'),
            ])

        return argv

    def execute_file(self, command, file, tmp, task_vars):
        argv = self.get_args(command)
        argv.extend([
            '-f',
            file,
        ])

        role_path = task_vars.get('role_path')
        command_args=dict(
            argv=argv,
            chdir=role_path,
        )

        display.display('kubectl %s' % (command_args))
        return self._execute_module(
            module_name='command',
            module_args=command_args,
            task_vars=task_vars,
            tmp=tmp,
        )

    def execute_command(self, command, tmp, task_vars):
        argv = self.get_args(command)

        role_path = task_vars.get('role_path')
        command_args=dict(
            argv=argv,
            chdir=role_path,
        )

        display.display('kubectl %s' % (command_args))
        return self._execute_module(
            module_name='command',
            module_args=command_args,
            task_vars=task_vars,
            tmp=tmp,
        )