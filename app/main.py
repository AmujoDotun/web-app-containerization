from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
import uvicorn
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI()

# Instrument the app with default metrics
Instrumentator().instrument(app).expose(app)

@app.get("/")
def read_root():
    return {"message": "Hello, World!"}

@app.get("/healthz")
def healthz():
    """Liveness probe."""
    return JSONResponse(content={"status": "ok"})

@app.get("/readyz")
def readyz():
    """Readiness probe."""
    # In a real application, this would check for database connections, etc.
    return JSONResponse(content={"status": "ready"})

# A simple endpoint to simulate load
@app.get("/load")
def load():
    # Simulate some CPU-bound work
    for i in range(1000000):
        _ = i * i
    return {"message": "Load simulation complete"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080)