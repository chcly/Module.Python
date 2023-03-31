#include "Source/Intrepreter.h"
#include <cstdlib>
#include <iostream>
#include "Source/PyProxy.h"
#include "Utils/Win32/CrtUtils.h"

namespace Rt2
{
    using WString = std::wstring;

    class WStringUtils
    {
    public:
        static WString from(const String& str)
        {
            size_t   size;
            wchar_t* dec = Py_DecodeLocale(str.c_str(), &size);
            WString  v   = {dec, size};
            PyMem_RawFree(dec);
            return v;
        }
    };

    using Wsu = WStringUtils;

}  // namespace Rt2

namespace Rt2::Python
{
    Interpreter::Interpreter()
    {
        if (!Py_IsInitialized())
        {
            Py_SetProgramName(L"Rt2::Python::Interpreter");
            Py_Initialize();
            globals();
            locals();
        }
    }

    Interpreter::~Interpreter()
    {
        if (Py_IsInitialized())
        {
            Py_DECREF(_globals);
            _globals = nullptr;
            Py_DECREF(_locals);
            _locals = nullptr;
            Py_FinalizeEx();
        }
    }

    Script Interpreter::compile(IStream& script)
    {
        Script val;
        val.compile(script);
        return val;
    }

    void Interpreter::run(IStream& script)
    {
        OutputStringStream oss;
        Su::copy(oss, script, false);
        PyRun_SimpleString(oss.str().c_str());
    }

    PyObject* Interpreter::globals()
    {
        if (!_globals)
        {
            _globals = PyDict_New();
            PyDict_SetItemString(_globals, "__builtins__", PyEval_GetBuiltins());
        }
        return _globals;
    }

    PyObject* Interpreter::locals()
    {
        if (!_locals)
            _locals = PyDict_New();
        return _locals;
    }

    PyObject* Interpreter::_globals = nullptr;
    PyObject* Interpreter::_locals  = nullptr;

}  // namespace Rt2::Python
