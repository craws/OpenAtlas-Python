from pathlib import Path

from wand.image import Image

from openatlas import app, logger


class ImageProcessing:

    @staticmethod
    def resize_image(filename: str) -> None:
        name = filename.rsplit('.', 1)[0].lower()
        file_format = filename.rsplit('.', 1)[1].lower()
        if file_format in app.config['PROCESSED_IMAGE_EXT']:
            for size in app.config['PROCESSED_IMAGE_SIZES']:
                ImageProcessing.create_thumbnail(name, file_format, size)

    @staticmethod
    def create_thumbnail(filename: str, file_format: str, size: str) -> None:
        try:
            ImageProcessing.validate_folder(size, app.config['THUMBNAIL_DIR'])
            path = str(Path(app.config['UPLOAD_DIR']) / f"{filename}.{file_format}[0]")
            with Image(filename=path) as src:
                with src.convert('png') as img:
                    img.transform(resize=size + 'x' + size + '>')
                    img.save(
                        filename=str(Path(app.config['THUMBNAIL_DIR']) / size / (filename + '.png')))
        except Exception as e:
            logger.log('error', 'thumbnail creation', 'failed to save', e)

    @staticmethod
    def check_processed_image(filename: str) -> bool:
        name = filename.rsplit('.', 1)[0].lower()
        file_format = filename.rsplit('.', 1)[1].lower()
        try:
            for size in app.config['PROCESSED_IMAGE_SIZES']:
                p = Path(app.config['THUMBNAIL_DIR']) / size / f'{name}.png'
                if not p.is_file():
                    ImageProcessing.create_thumbnail(name, file_format, size)
            return True
        except Exception:
            return False

    @staticmethod
    def validate_folder(folder: str, path: str) -> bool:
        folder_to_check = Path(path) / folder
        if folder_to_check.is_dir():
            return True
        if folder_to_check.mkdir():
            return True
        return False

    @staticmethod
    def display_as_thumbnail(filename: str, size: str) -> None:
        path = str(app.config['UPLOAD_DIR']) + '/' + filename
        with Image(filename=path) as img:
            img.transform(resize=size + 'x' + size + '>')
            img.save(filename=f"{app.config['OA_TMP_DIR']}/{filename}")
