#pragma once
#include "Script.h"
#include "Utils/String.h"

namespace Rt2::Python
{
    class Interpreter
    {
    private:

        static PyObject *_globals;
        static PyObject *_locals;

    public:
        Interpreter();

        ~Interpreter();

        Script compile(IStream& script);

        void run(IStream& script);

        static PyObject* globals();
        static PyObject* locals();
    };

}  // namespace Rt2::Python
