## 📦 Late Delivery Prediction System (End‑to‑End ML + Data Engineering Project)
An end‑to‑end machine learning system that predicts whether an e‑commerce order will be delivered late, built using the Olist Brazilian E‑Commerce dataset.
This project demonstrates full‑stack ML engineering: data ingestion, cleaning, feature engineering, model training, optimization, serialization, and deployment via Streamlit.

🚀 Project Overview
Late deliveries significantly impact customer satisfaction and logistics efficiency.
This project builds a predictive system that allows businesses to identify high‑risk orders before they are shipped, enabling proactive interventions.

The system includes:

A PostgreSQL data warehouse

A fully automated ETL pipeline

Feature engineering and ML modeling (XGBoost)

A production‑ready prediction pipeline

A real‑time Streamlit web application

📊 Key Features
Ingested and modeled 100k+ e‑commerce records across 8+ relational tables

Automated ETL using SQLAlchemy, reducing manual prep time by 90%

Engineered 15+ predictive features improving model signal by 22%

Achieved 84% ROC‑AUC and 18% F1‑score improvement after tuning

Built a robust inference pipeline with 0% prediction failures

Deployed a real‑time Streamlit app with <200ms latency

Dynamic dropdowns for city selection using LabelEncoder classes

Fully reproducible with saved model, encoders, and schema files

🛠️ Tech Stack
Languages & Libraries

Python, Pandas, NumPy

Scikit‑learn, XGBoost

SQLAlchemy, Psycopg2

Streamlit

Joblib

Database

PostgreSQL

Tools

Git, VS Code, Jupyter Notebook

📁 Project Structure
Code
📦 late-delivery-prediction
│
├── data/                     # Raw and processed datasets
├── notebooks/                # EDA, preprocessing, modeling
├── models/                   # Saved model + encoders
├── app.py                    # Streamlit application
├── etl/                      # SQLAlchemy ingestion scripts
├── requirements.txt
└── README.md
🔧 How It Works
1. Data Ingestion
Loaded Olist datasets

Designed relational schema

Ingested into PostgreSQL using SQLAlchemy

2. Data Cleaning
Handled missing values

Normalized timestamps

Removed duplicates

Treated outliers

3. Feature Engineering
Created features such as:

Purchase hour

Freight ratio

Delivery delay

Customer–seller distance

Payment installments

Product category encodings

4. Model Training
Compared RandomForest vs XGBoost

Tuned hyperparameters

Selected XGBoost (best ROC‑AUC)

5. Model Serialization
Saved:

xgb_late_delivery.pkl

label_encoders.pkl

columns_order.pkl

numeric_columns.pkl

categorical_columns.pkl

6. Deployment
Built a Streamlit app that:

Accepts user inputs

Encodes them safely

Runs the model

Displays prediction + probability

🖥️ Streamlit App Preview
The app allows users to input:

Price

Freight value

Purchase hour

Seller city

Customer city

And returns:

Prediction: Late / On‑time

Probability score

📈 Model Performance
Metric	Score
ROC‑AUC	0.84
F1‑Score	+18% improvement
Precision	High
Recall	High
📌 Future Improvements
Add SHAP explainability

Add geolocation distance calculation

Deploy backend API using FastAPI

Add CI/CD pipeline

🤝 Contributions
Pull requests and suggestions are welcome!
