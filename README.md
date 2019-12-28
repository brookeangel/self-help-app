# Modern Health

## Development
- This project uses Python3 & PSQL; make sure you have those installed first
- Activate venv: `python3 -m venv venv` & `source venv/bin/activate`
- Install dependencies: `pip3 install -r requirements.txt`
- Create database:
```
> psql
# create database modern_health_dev;
```
- Run DB migrations: `flask db upgrade`
- Start the project: `flask run`
- View in your browser at `localhost:5000`
