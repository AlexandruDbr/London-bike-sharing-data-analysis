import pandas as pd
import pyodbc
from sqlalchemy import create_engine
from sqlalchemy import URL
import os

engine = URL.create(
    "mssql+pyodbc",
    host= "ALEXANDRUPC\SQLSERVER2022", 
    database="London_bike_sharing",
    query={
        "driver": "ODBC Driver 18 for SQL Server",
        "TrustServerCertificate": "yes",
        "authentication": "ActiveDirectoryIntegrated",
    },
)

conn = create_engine(engine)

p = os.getcwd()+'\LondonBikeJourneyAug2023.csv'

df = pd.read_csv(p)

df.to_sql('Bikeuse2023', conn)



