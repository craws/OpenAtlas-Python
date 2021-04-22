class SexEstimation:
    options = [
        ('', ''),
        ('1', 'Female'),
        ('2', 'Female?'),
        ('3', 'Indifferent'),
        ('4', 'Male?'),
        ('5', 'Male'),
        ('6', 'Not preserved')]

    features = {
        'Skull': {
            'Glabella': 3,
            'Arcus superciliaris': 2,
            'Tuber frontalis and parietalis': 2,
            'Inclinatio frontalis': 1,
            'Processus mastoideus': 3,
            'Relief of planum nuchale': 3,
            'Protuberantia occipitalis externa': 2,
            'Processus zygomaticus': 3,
            'Os zygomaticum': 2,
            'Crista supramastoideum': 2,
            'Margo supraorbitalis': 1,
            'Shape of orbita': 1},
        'Mandible': {
            'Overall apperence': 3,
            'Mentum': 2,
            'Angulus': 1,
            'Margo inferior (M2)': 1,
            'Angle': 1},
        'Pelvis': {
            'Sulcus praeauricularis': 3,
            'Incisura ischiadica major': 3,
            'Angulus pubis': 2,
            'Arc composé': 2,
            'Os coxae': 2,
            'Foramen obturatum': 2,
            'Corpus ossis ischii': 2,
            'Crista iliaca': 1,
            'Fossa iliaca': 1,
            'Pelvis major': 1,
            'Auricular area': 1,
            'Sacrum': 1,
            'Fossa acetabuli': 1},
        'Robusticity': {
            'Humerus': 1,
            'Femur': 1}}
