# Modern Health

## Future Directions
Important things to add that are not-yet-here:
- Python tests
- Generalize frontend build (right now, we only build one Elm app, but this should be generalized to build more)

## Development

- This project uses Python3 & PSQL; make sure you have those installed first

### Python Setup
- Activate venv: `python3 -m venv venv` & `source venv/bin/activate`
- Install dependencies: `pip3 install -r requirements.txt`

### Database Setup
- Create database:
```
> psql
# create database modern_health_dev;
```
- Run DB migrations: `flask db upgrade`

### Build Elm
- `npm install`
- `npm run build-elm`

### Start Server
- Start the project: `flask run`
- View in your browser at `localhost:5000`
