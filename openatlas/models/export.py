import os
import shutil
import subprocess

from flask import g, request
from flask_login import current_user
from flask_wtf import FlaskForm

from openatlas import app
from openatlas.models.date import Date


class Export:

    @staticmethod
    def export_csv(form: FlaskForm) -> None:
        """Create CSV file(s) in export/csv folder, filename begins with current date_time."""
        import pandas.io.sql as psql
        date_string = Date.current_date_for_filename()
        path = app.config['EXPORT_DIR'] / 'csv'
        if form.zip.data:
            path = app.config['TMP_DIR'] / (date_string + '_openatlas_csv_export')
            if path.is_dir():
                shutil.rmtree(path)  # pragma: no cover
            path.mkdir()
        tables = {
            'model_class': ['id', 'name', 'code'],
            'model_class_inheritance': ['id', 'super_code', 'sub_code'],
            'model_entity': [
                'id',
                'name',
                'description',
                'class_code',
                "replace(to_char(begin_from, 'yyyy-mm-dd BC'), ' AD', '')",
                "replace(to_char(begin_to, 'yyyy-mm-dd BC'), ' AD', '')",
                'begin_comment',
                "replace(to_char(end_from, 'yyyy-mm-dd BC'), ' AD', '')",
                "replace(to_char(end_to, 'yyyy-mm-dd BC'), ' AD', '')",
                'end_comment'],
            'model_link': [
                'id',
                'property_code',
                'domain_id',
                'range_id',
                'type_id',
                'description',
                "replace(to_char(begin_from, 'yyyy-mm-dd BC'), ' AD', '')",
                "replace(to_char(begin_to, 'yyyy-mm-dd BC'), ' AD', '')",
                'begin_comment',
                "replace(to_char(end_from, 'yyyy-mm-dd BC'), ' AD', '')",
                "replace(to_char(end_to, 'yyyy-mm-dd BC'), ' AD', '')",
                'end_comment'],
            'model_property': [
                'id', 'code', 'range_class_code', 'domain_class_code', 'name', 'name_inverse'],
            'model_property_inheritance': ['id', 'super_code', 'sub_code'],
            'gis_point': ['id', 'entity_id', 'name', 'description', 'type'],
            'gis_linestring': ['id', 'entity_id', 'name', 'description', 'type'],
            'gis_polygon': ['id', 'entity_id', 'name', 'description', 'type']}
        gis_tables = ['gis_point', 'gis_linestring', 'gis_polygon']
        for table, fields in tables.items():
            if getattr(form, table).data:
                if form.timestamps.data:
                    fields.append('created')
                    fields.append('modified')
                if table in gis_tables:
                    if form.gis_format.data == 'wkt':
                        fields.append("ST_AsText(geom)")
                    elif form.gis_format.data == 'coordinates':
                        if table == 'gis_point':
                            fields.append("ST_X(geom) || ' ' || ST_Y(geom) AS coordinates")
                        else:
                            fields.append("""
                                ST_X(public.ST_PointOnSurface(geom)) || ' ' ||
                                ST_Y(public.ST_PointOnSurface(geom)) AS polygon_center_point""")
                    else:
                        fields.append('geom')
                sql = f"SELECT {','.join(fields)} FROM {table.replace('_', '.', 1)};"
                data_frame = psql.read_sql(sql, g.db)
                data_frame.to_csv(path / (date_string + '_' + table + '.csv'), index=False)
        if form.zip.data:
            info = 'CSV export from: {host}\n'.format(host=request.headers['Host'])
            info += 'Created: {date} by {user}\nOpenAtlas version: {version}'.format(
                date=date_string,
                user=current_user.username,
                version=app.config['VERSION'])
            with open(path / 'info.txt', "w") as file:
                print(info, file=file)
            zip_file = app.config['EXPORT_DIR'] / 'csv' / (date_string + '_csv')
            shutil.make_archive(zip_file, 'zip', path)
            shutil.rmtree(path)

    @staticmethod
    def export_sql() -> bool:
        """Creates pg_dump file in export/sql folder, filename begins with current date_time."""
        file = app.config['EXPORT_DIR'] / 'sql' / (Date.current_date_for_filename() + '_dump.sql')
        if os.name == 'posix':
            command = """pg_dump -h {host} -d {database} -U {user} -p {port} -f {file}""".format(
                host=app.config['DATABASE_HOST'],
                database=app.config['DATABASE_NAME'],
                port=app.config['DATABASE_PORT'],
                user=app.config['DATABASE_USER'],
                file=file)
            try:
                subprocess.Popen(
                    command,
                    shell=True,
                    stdin=subprocess.PIPE,
                    env={'PGPASSWORD': app.config['DATABASE_PASS']}).wait()
                subprocess.Popen(['7z', 'a', str(file) + '.7z', file]).wait()
                file.unlink()
            except Exception:  # pragma: no cover
                return False
        else:  # pragma: no cover
            os.popen("""{pg_dump} -h {host} -d {database} -U {user} -p {port} > {file}""".format(
                host='127.0.0.1',
                database=app.config['DATABASE_NAME'],
                port=app.config['DATABASE_PORT'],
                user=app.config['DATABASE_USER'],
                pg_dump='"' + shutil.which('pg_dump') + '"',
                file=file))
        return True
