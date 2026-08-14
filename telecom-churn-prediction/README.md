# Telecom Customer Churn Prediction & CLV Analysis

## Overview
End-to-end machine learning pipeline to predict customer churn 
for a telecom company and identify high-value at-risk customers 
using Customer Lifetime Value analysis.

## Results
- Random Forest: 97.47% accuracy, AUC-ROC 0.99
- Compared 6 classifiers: Random Forest, Gradient Boosting, 
  Decision Tree, SVM, Neural Network, KNN
- Identified top revenue customers at risk of churning

## Tools & Technologies
- Python, Pandas, NumPy, Scikit-learn
- Matplotlib, Seaborn
- Tableau (5-dashboard presentation)

## Key Steps
1. Data cleaning and preprocessing (7,043 customers, 38 features)
2. Handling class imbalance with RandomOverSampler
3. EDA — chi-square tests, ANOVA, correlation analysis
4. Feature engineering and importance analysis
5. Hyperparameter tuning with Grid Search
6. CLV integration for business prioritisation

## Top Predictors of Churn
- Contract type
- Monthly charges
- Tenure in months


