import pandas as pd
from sklearn.preprocessing import LabelEncoder

class Preprocessor:
    def __init__(self):
        self.label_encoders = {}
        self.numeric_cols = None
        self.categorical_cols = None
        self.columns_order = None

    def fit(self, X):
        # Identify column types
        self.numeric_cols = X.select_dtypes(include=['int64','float64']).columns
        self.categorical_cols = X.select_dtypes(include=['object']).columns

        # Fit label encoders
        for col in self.categorical_cols:
            le = LabelEncoder()
            le.fit(X[col].astype(str))
            self.label_encoders[col] = le

        # Save column order
        self.columns_order = X.columns.tolist()

    def transform(self, X):
        X = X.copy()

        # Fill numeric NaN
        X[self.numeric_cols] = X[self.numeric_cols].fillna(X[self.numeric_cols].median())

        # Fill categorical NaN
        X[self.categorical_cols] = X[self.categorical_cols].fillna("unknown")

        # Encode categorical
        for col in self.categorical_cols:
            le = self.label_encoders[col]
            X[col] = le.transform(X[col].astype(str))

        # Ensure same column order
        X = X[self.columns_order]

        return X


prep = Preprocessor()
prep.fit(X_train)

X_train_clean = prep.transform(X_train)
X_test_clean = prep.transform(X_test)
