#include <cstdio>
#include "Python.h"
#include "Utils/String.h"
#include "gtest/gtest.h"

namespace Rt2::Python
{
    class Interpreter
    {
    public:
        Interpreter()
        {
            Py_Initialize();
        }

        ~Interpreter()
        {
            Py_Finalize();
        }

        void run(const String& script)
        {
            PyRun_SimpleString(script.c_str());
        }
    };

}  // namespace Rt2::Python

GTEST_TEST(Python, Startup)
{
    Rt2::Python::Interpreter vm;
    vm.run("print('hello')");
}


