# Python

Skeleton code for embedding python.

## Testing

The testing directory is setup to work with [googletest](https://github.com/google/googletest).
It contains the initial setup for testing this library as a standalone module using GitHub actions.

## Building

It builds with cmake, and it has been tested on Windows and Unix platforms using
the Visual Studio an Unix MakeFile cmake generators.

### Building with CMake and Make

```sh
mkdir build
cd build
cmake .. -DPython_BUILD_TEST=ON -DPython_AUTO_RUN_TEST=ON
make
```

### Optional defines

| Option                   | Description                                          | Default |
| :----------------------- | :--------------------------------------------------- | :-----: |
| Python_BUILD_TEST         | Build the unit test program.                         |   ON    |
| Python_AUTO_RUN_TEST      | Automatically run the test program.                  |   OFF   |
| Python_USE_STATIC_RUNTIME | Build with the MultiThreaded(Debug) runtime library. |   ON    |
