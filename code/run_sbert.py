
import numpy as np
import pandas as pd
from sentence_transformers import SentenceTransformer
model = SentenceTransformer('paraphrase-MiniLM-L6-v2')



sample=pd.read_csv('../data/expt_3/pre_sbert.csv')
sentence_list=sample['words'].tolist()

embeddings = model.encode(sentence_list)

np.save('../data/expt_3/post_sbert.npy', embeddings)


sample=pd.read_csv('../data/expt_2/pre_sbert.csv')
sentence_list=sample['words'].tolist()

embeddings = model.encode(sentence_list)

np.save('../data/expt_2/post_sbert.npy', embeddings)


sample=pd.read_csv('../data/expt_1/pre_sbert.csv')
sentence_list=sample['words'].tolist()

embeddings = model.encode(sentence_list)

np.save('../data/expt_1/post_sbert.npy', embeddings)
