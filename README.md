# Python

Skeleton code for embedding python.


## Testing

The Test directory is setup to work with [googletest](https://github.com/google/googletest).

## Building

Building with CMake and Make.

```sh
mkdir build
cd build
cmake .. -DPython_BUILD_TEST=ON -DPython_AUTO_RUN_TEST=ON
make
```

### Optional defines

| Option                    | Description                                          | Default |
| :------------------------ | :--------------------------------------------------- | :-----: |
| Python_BUILD_TEST         | Build the unit test program.                         |   ON    |
| Python_AUTO_RUN_TEST      | Automatically run the test program.                  |   OFF   |
| Python_USE_STATIC_RUNTIME | Build with the MultiThreaded(Debug) runtime library. |   ON    |
