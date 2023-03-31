#include <cstdio>
#include "Utils/String.h"
#include "gtest/gtest.h"
#include "Source/Intrepreter.h"

GTEST_TEST(Python, Startup)
{
    Rt2::Python::Interpreter vm;

    Rt2::StringStream ss;
    ss << "import sys\n";
    ss << "print( dir(sys) )\n";
    vm.compile(ss).exec();
}


