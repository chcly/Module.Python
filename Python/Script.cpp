#include "Python/Script.h"
#include "Python/Intrepreter.h"
#include "Python/PyProxy.h"

namespace Rt2::Python
{
    Script::Script() = default;

    Script::Script(const Script& sc)
    {
        if (sc._script)
        {
            Py_INCREF(sc._script);
            _script = sc._script;
        }
    }

    Script::~Script()
    {
        if (_script)
        {
            Py_DECREF(_script);
            _script = nullptr;
        }
    }

    Script& Script::operator=(const Script& sc)
    {
        if (this != &sc)
            *this = Script(sc);
        return *this;
    }

    void Script::compile(IStream& script)
    {
        OutputStringStream oss;
        Su::copy(oss, script, false);

        _script = Py_CompileString(oss.str().c_str(),
                                   "compile",
                                   Py_file_input);
    }

    void Script::exec() const
    {
        if (_script)
        {
            if (const auto result = PyEval_EvalCode(_script,
                                                    Interpreter::globals(),
                                                    Interpreter::locals()))
                Py_DecRef(result);
        }
    }

    Script::operator PyObject*() const
    {
        return _script;
    }
}  // namespace Rt2::Python
