import string
from nltk.corpus import stopwords
from sklearn.feature_extraction.text import CountVectorizer
import joblib

# Define text preprocessing function
def text_process(mess):
    """
    Takes in a string of text, then performs the following:
    1. Remove all punctuation
    2. Remove all stopwords
    3. Returns a list of the cleaned text
    """
    STOPWORDS = stopwords.words('english') + ['u', 'ü', 'ur', '4', '2', 'im', 'dont', 'doin', 'ure']
    # Check characters to see if they are in punctuation
    nopunc = [char for char in mess if char not in string.punctuation]

    # Join the characters again to form the string.
    nopunc = ''.join(nopunc)
    
    # Now just remove any stopwords
    return ' '.join([word for word in nopunc.split() if word.lower() not in STOPWORDS])

# Load trained CountVectorizer
def load_vectorizer(vectorizer_path):
    return joblib.load(vectorizer_path)

# Load Model
def load_model(model_path):
    return joblib.load(model_path)

def ready_input(input):
    clean_new_message = text_process(input)

    # Load the trained vectorizer
    vect = load_vectorizer('vectorizer.pkl')

    # Vectorize the new message
    new_message_dtm = vect.transform([clean_new_message])
    return new_message_dtm
