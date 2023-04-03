#include <cstdio>
#include "Utils/String.h"
#include "gtest/gtest.h"
#include "Python/Intrepreter.h"
#include "Utils/StackStream.h"

GTEST_TEST(Python, Startup)
{
    Rt2::Python::Interpreter vm;
    Rt2::StringStream ss;
    Rt2::OutputStreamStack out;


    auto loc = out.push(&ss);
    out.println("import sys");
    out.println("print (dir(sys))");

    out.flush();
    vm.compile(ss).exec();
}


