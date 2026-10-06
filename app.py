import streamlit as st
import pandas as pd
from datetime import datetime

st.set_page_config(
    page_title="Azure Streamlit Test",
    page_icon="✅",
    layout="centered"
)

st.title("✅ Streamlit is running on Azure")

st.success("If you can see this page, your deployment is working.")

st.write("Current server time:")
st.code(str(datetime.now()))

st.subheader("Test interaction")

name = st.text_input("Enter your name")

if st.button("Test button"):
    if name:
        st.success(f"Hello {name} — the app is working.")
    else:
        st.info("The button works. Enter a name if you want.")

st.subheader("Test data")

df = pd.DataFrame({
    "Product": ["Seal", "Flange Extender", "Adhesive Remover"],
    "Samples": [120, 85, 64],
    "Conversion": [0.12, 0.08, 0.10]
})

st.dataframe(df, use_container_width=True)

st.bar_chart(
    df.set_index("Product")["Samples"]
)

st.caption("Deployed using Streamlit + Azure App Service")