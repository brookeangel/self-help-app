# Self-Help App

## Future Directions
Important things to add that are not-yet-here:
- Python tests
- Generalize frontend build (right now, we only build one Elm entrypoint, but this should be generalized to build more)
- Dockerize, so that all we have to run is `docker-compose up` to start this project

## Development

- This project uses Python3 & PSQL; make sure you have those installed first

### Python Setup
- Activate venv: `python3 -m venv venv` & `source venv/bin/activate`
- Install dependencies: `pip3 install -r requirements.txt`

### Database Setup
- Create database:
```
> psql
# create database self_help_dev;
```
- Run DB migrations: `flask db upgrade`
- Seed DB: `flask seed`

### Build Elm
- `npm install`
- `npm run build-elm`

### Start Server
- Start the project: `flask run`
- View in your browser at `localhost:5000`

### Testing
- Elm tests: `npm test`

### License
[License](./LICENSE.txt)
