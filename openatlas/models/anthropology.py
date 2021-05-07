from typing import Dict

from flask import g

from openatlas.models.entity import Entity

# Todo:
# - if saved one of the sex features types are shown as default type
# - if entity is updated, feature types get deleted
# - remove default


class SexEstimation:

    options = {
        '': 0,
        'Female': -2,
        'Female?': -1,
        'Indifferent': 0,
        'Male?': 1,
        'Male': 2,
        'Not preserved': 0}

    features = {
        'Skull': {
            'Glabella': {
                'value': 3,
                'female': 'smooth, non-projecting',
                'male': 'prominent, projecting'},
            'Arcus superciliaris': {
                'value': 2,
                'female': '',
                'male': ''},
            'Tuber frontalis and parietalis': {
                'value': 2,
                'female': '',
                'male': ''},
            'Inclinatio frontalis': {
                'value': 1,
                'female': '',
                'male': ''},
            'Processus mastoideus': {
                'value': 3,
                'female': '',
                'male': ''},
            'Relief of planum nuchale': {
                'value': 3,
                'female': '',
                'male': ''},
            'Protuberantia occipitalis externa': {
                'value': 2,
                'female': '',
                'male': ''},
            'Processus zygomaticus': {
                'value': 3,
                'female': '',
                'male': ''},
            'Os zygomaticum': {
                'value': 2,
                'female': '',
                'male': ''},
            'Crista supramastoideum': {
                'value': 2,
                'female': '',
                'male': ''},
            'Margo supraorbitalis': {
                'value': 1,
                'female': '',
                'male': ''},
            'Shape of orbita': {
                'value': 1,
                'female': '',
                'male': ''}},
        'Mandible': {
            'Overall apperence': {
                'value': 3,
                'female': '',
                'male': ''},
            'Mentum': {
                'value': 2,
                'female': '',
                'male': ''},
            'Angulus': {
                'value': 1,
                'female': '',
                'male': ''},
            'Margo inferior (M2)': {
                'value': 1,
                'female': '',
                'male': ''},
            'Angle': {
                'value': 1,
                'female': '',
                'male': ''}},
        'Pelvis': {
            'Sulcus praeauricularis': {
                'value': 3,
                'female': '',
                'male': ''},
            'Incisura ischiadica major': {
                'value': 3,
                'female': '',
                'male': ''},
            'Angulus pubis': {
                'value': 2,
                'female': '',
                'male': ''},
            'Arc composé': {
                'value': 2,
                'female': '',
                'male': ''},
            'Os coxae': {
                'value': 2,
                'female': '',
                'male': ''},
            'Foramen obturatum': {
                'value': 2,
                'female': '',
                'male': ''},
            'Corpus ossis ischii': {
                'value': 2,
                'female': '',
                'male': ''},
            'Crista iliaca': {
                'value': 1,
                'female': '',
                'male': ''},
            'Fossa iliaca': {
                'value': 1,
                'female': '',
                'male': ''},
            'Pelvis major': {
                'value': 1,
                'female': '',
                'male': ''},
            'Auricular area': {
                'value': 1,
                'female': '',
                'male': ''},
            'Sacrum': {
                'value': 1,
                'female': '',
                'male': ''},
            'Fossa acetabuli': {
                'value': 1,
                'female': '',
                'male': ''}},
        'Robusticity': {
            'Humerus': {
                'value': 1,
                'female': '',
                'male': ''},
            'Femur': {
                'value': 1,
                'female': '',
                'male': ''}}}

    @staticmethod
    def get_by_name(feature_name):
        for group in SexEstimation.features.values():
            for name, values in group.items():
                if name == feature_name:
                    return values['type_id']

    @staticmethod
    def save(entity: Entity, data: Dict[str, str]) -> None:
        for key, item in data.items():
            entity.link('P2', g.nodes[SexEstimation.get_by_name(key)], item)
        print(f'This values {data}')
