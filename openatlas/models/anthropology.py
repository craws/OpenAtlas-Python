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
                'female': 'slight',
                'male': 'prominent'},
            'Tuber frontalis and parietalis': {
                'value': 2,
                'female': 'marked',
                'male': 'reduced or absent'},
            'Inclinatio frontalis': {
                'value': 1,
                'female': 'vertical',
                'male': 'inclined posteriorly'},
            'Processus mastoideus': {
                'value': 3,
                'female': 'small, inflected below vault',
                'male': 'large, vertical or everted'},
            'Relief of planum nuchale': {
                'value': 3,
                'female': 'smooth',
                'male': 'ridged'},
            'Protuberantia occipitalis externa': {
                'value': 2,
                'female': 'small',
                'male': 'large'},
            'Processus zygomaticus': {
                'value': 3,
                'female': 'narrow',
                'male': 'broad'},
            'Os zygomaticum': {
                'value': 2,
                'female': 'short, smooth lower margin',
                'male': 'tall, roughened lower margin'},
            'Crista supramastoideum': {
                'value': 2,
                'female': 'short',
                'male': 'long, extending posteriorly'},
            'Margo supraorbitalis': {
                'value': 1,
                'female': 'sharp edges',
                'male': 'rounded edges'},
            'Shape of orbita': {
                'value': 1,
                'female': 'circular',
                'male': 'quadrangular'}},
        'Mandible': {
            'Overall apperence': {
                'value': 3,
                'female': 'grazil',
                'male': 'pronounced'},
            'Mentum': {
                'value': 2,
                'female': 'small and rounded',
                'male': 'large and projecting'},
            'Angulus': {
                'value': 1,
                'female': 'obtuse',
                'male': 'perpendicular'},
            'Margo inferior (M2)': {
                'value': 1,
                'female': 'thin',
                'male': 'thick'},
            'Angle': {
                'value': 1,
                'female': 'smooth edges',
                'male': 'everted edges'}},
        'Pelvis': {
            'Sulcus praeauricularis': {
                'value': 3,
                'female': 'often present',
                'male': 'absent'},
            'Incisura ischiadica major': {
                'value': 3,
                'female': 'u-shaped, obtuse angle (>60°)',
                'male': 'v-shaped, acute angle (~30°)'},
            'Angulus pubis': {
                'value': 2,
                'female': 'broad, u-shaped',
                'male': 'narrow, v-shaped'},
            'Arc composé': {
                'value': 2,
                'female': 'double curve',
                'male': 'single curve'},
            'Os coxae': {
                'value': 2,
                'female': 'low, broad, with spreading alae ossis illii and low muscle relief',
                'male': 'high, narrow, with strong muscle relief'},
            'Foramen obturatum': {
                'value': 2,
                'female': 'small, wide, triangular',
                'male': 'large, tall ovoid'},
            'Corpus ossis ischii': {
                'value': 2,
                'female': 'narrow',
                'male': 'broad'},
            'Crista iliaca': {
                'value': 1,
                'female': 'flat s-shaped',
                'male': 'pronounced s-shaped'},
            'Fossa iliaca': {
                'value': 1,
                'female': 'small, broad',
                'male': 'tall, narrow'},
            'Pelvis major': {
                'value': 1,
                'female': 'broad',
                'male': 'narrow'},
            'Auricular area': {
                'value': 1,
                'female': 'narrow, on elevated plateau',
                'male': 'wide, in plane of iliac surface'},
            'Sacrum': {
                'value': 1,
                'female': 'sacral ala broader than body of S1, curvature ectends from S3 to S5',
                'male': 'sacral ala narrower than S1, curvature ectends from S1 to S5'},
            'Fossa acetabuli': {
                'value': 1,
                'female': 'small, faces antero-laterally',
                'male': 'large, faces more laterally'}},
        'Robusticity': {
            'Humerus': {
                'value': 1,
                'female': 'grazil',
                'male': 'pronounced'},
            'Femur': {
                'value': 1,
                'female': 'grazil',
                'male': 'pronounced'}}}

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
