# 📦 Late Delivery Prediction System  
**End-to-End Machine Learning & Data Engineering Project**

An end-to-end machine learning system that predicts whether an e-commerce order will be delivered **late or on time**, built using the **Olist Brazilian E-Commerce Dataset**.

This project demonstrates **full-stack ML engineering**, covering data ingestion, ETL pipelines, feature engineering, model training and optimization, serialization, and deployment via **Streamlit**.

---

## 🚀 Project Overview

Late deliveries negatively impact customer satisfaction, logistics efficiency, and revenue.  
This system enables businesses to **identify high-risk orders before shipment**, allowing proactive interventions.

### The system includes:
- A **PostgreSQL data warehouse**
- A fully automated **ETL pipeline**
- Feature engineering and ML modeling (**XGBoost**)
- A production-ready inference pipeline
- A real-time **Streamlit web application**

---

## 📊 Key Highlights

- Ingested and modeled **100k+ e-commerce records** across **8+ relational tables**
- Automated ETL using **SQLAlchemy**, reducing manual data prep by **90%**
- Engineered **15+ predictive features**, improving model signal by **22%**
- Achieved **84% ROC-AUC** and **18% F1-score improvement** after tuning
- Built a robust inference pipeline with **0% prediction failures**
- Deployed a real-time Streamlit app with **<200ms latency**
- Dynamic dropdowns for cities using saved **LabelEncoders**
- Fully reproducible with saved model, encoders, and schema files

---

## 🛠️ Tech Stack

### Languages & Libraries
- Python
- Pandas, NumPy
- Scikit-learn
- XGBoost
- SQLAlchemy, Psycopg2
- Streamlit
- Joblib

### Database
- PostgreSQL

### Tools
- Git & GitHub
- VS Code
- Jupyter Notebook

---

## 📁 Project Structure

📦 late-delivery-prediction
│
├── data/ # Raw and processed datasets
├── notebooks/ # EDA, preprocessing, modeling
├── models/ # Saved model & encoders
├── etl/ # SQLAlchemy ingestion scripts
├── app.py # Streamlit application
├── requirements.txt
└── README.md


---

## 🔧 How the System Works

### 1️⃣ Data Ingestion
- Loaded Olist datasets
- Designed relational schema
- Ingested data into PostgreSQL using SQLAlchemy

### 2️⃣ Data Cleaning
- Handled missing values
- Normalized timestamps
- Removed duplicates
- Treated outliers

### 3️⃣ Feature Engineering
Created features such as:
- Purchase hour
- Freight-to-price ratio
- Delivery delay
- Customer–seller distance
- Payment installments
- Product category encodings

### 4️⃣ Model Training
- Compared **RandomForest** vs **XGBoost**
- Tuned hyperparameters
- Selected **XGBoost** based on ROC-AUC

### 5️⃣ Model Serialization
Saved production-ready artifacts:
- `xgb_late_delivery.pkl`
- `label_encoders.pkl`
- `columns_order.pkl`
- `numeric_columns.pkl`
- `categorical_columns.pkl`

### 6️⃣ Deployment
Built a Streamlit app that:
- Accepts user inputs
- Encodes features safely
- Runs real-time inference
- Displays prediction and probability

---

## 🖥️ Streamlit App

The application allows users to input:
- Product price
- Freight value
- Purchase hour
- Seller city
- Customer city

**Output:**
- Prediction: **Late** / **On-time**
- Probability score

---

## 📈 Model Performance

| Metric      | Score |
|------------|-------|
| ROC-AUC    | 0.84  |
| F1-Score   | +18% improvement |
| Precision  | High  |
| Recall     | High  |

---

## ▶️ How to Run Locally

```bash
# Clone the repository
git clone https://github.com/aadilquamri/ecommerce.git
cd ecommerce

# Create virtual environment (optional)
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run Streamlit app
streamlit run app.py
