from typing import Any, Dict, List, Optional, Union

from openatlas.database.settings import Settings as Db


class Settings:

    MODULES = ['map_overlay', 'sub_units']

    @staticmethod
    def get_settings() -> Dict[str, Any]:
        settings: Dict[str, Union[int, str, List[str]]] = {}
        for name in Settings.MODULES:  # Set empty in case it doesn't exist, e.g. after an upgrade
            settings['module_' + name] = ''
        for row in Db.get_settings():
            settings[row['name']] = row['value']
            if row['name'] in [
                    'table_rows',
                    'failed_login_forget_minutes',
                    'failed_login_tries',
                    'file_upload_max_size',
                    'minimum_password_length',
                    'random_password_length',
                    'reset_confirm_hours']:
                settings[row['name']] = int(row['value'])
            if row['name'] in ['mail_recipients_feedback', 'file_upload_allowed_extension']:
                settings[row['name']] = row['value'].split(' ')
        return settings

    @staticmethod
    def update(form: Any) -> None:
        for field in form:
            if field.type in ['CSRFTokenField', 'HiddenField', 'SubmitField']:
                continue
            value = field.data
            if field.type == 'BooleanField':
                value = 'True' if field.data else ''
            Db.update(field.name, value)

    @staticmethod
    def set_logo(file_id: Optional[int] = None) -> None:
        Db.set_logo(file_id if file_id else '')
