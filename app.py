import streamlit as st
import pandas as pd
import joblib

# Load saved assets
model = joblib.load("xgb_late_delivery.pkl")
label_encoders = joblib.load("label_encoders.pkl")
columns_order = joblib.load("columns_order.pkl")
num_cols = joblib.load("numeric_columns.pkl")
cat_cols = joblib.load("categorical_columns.pkl")
seller_city_options = sorted(label_encoders["seller_city"].classes_)
customer_city_options = sorted(label_encoders["customer_city"].classes_)


st.title("Late Delivery Prediction App")

# User inputs
price = st.number_input("Price", min_value=0.0)
freight_value = st.number_input("Freight Value", min_value=0.0)
purchase_hour = st.slider("Purchase Hour", 0, 23)
seller_city = st.selectbox("Seller City", seller_city_options)
customer_city = st.selectbox("Customer City", customer_city_options)


# Build input dictionary
input_dict = {
    "price": price,
    "freight_value": freight_value,
    "purchase_hour": purchase_hour,
    "seller_city": seller_city,
    "customer_city": customer_city
}

def predict(input_dict):
    # Create a DataFrame from input
    df = pd.DataFrame([input_dict])

    # Ensure all columns exist
    df = df.reindex(columns=columns_order, fill_value=0)

    # Fill missing numeric and categorical values
    df[num_cols] = df[num_cols].fillna(df[num_cols].median())
    df[cat_cols] = df[cat_cols].fillna("unknown")

    # Encode categorical columns
    for col in cat_cols:
        le = label_encoders[col]

        # Handle unseen labels
        df[col] = df[col].apply(lambda x: x if x in le.classes_ else "unknown")

        # Add "unknown" to encoder if missing
        if "unknown" not in le.classes_:
            le.classes_ = np.append(le.classes_, "unknown")

        df[col] = le.transform(df[col].astype(str))

    # Convert to numeric
    df = df.astype(float)

    # Predict
    prob = model.predict_proba(df)[0][1]
    pred = int(prob > 0.5)

    return pred, prob


if st.button("Predict"):
    pred, prob = predict(input_dict)

    st.write("### Prediction:")
    if pred == 1:
        st.error(f"Late Delivery (Probability: {prob:.2f})")
    else:
        st.success(f"On Time (Probability: {prob:.2f})")
