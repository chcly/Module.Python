#pragma once

#include "Utils/String.h"

struct _object;
using PyObject = _object;


namespace Rt2::Python
{
    class Script
    {
    private:

        PyObject *_script{nullptr};
        PyObject *_globals{nullptr};
        PyObject *_locals{nullptr};

    public:
        Script();
        Script(const Script &sc);
        ~Script();

        Script &operator =(const Script&sc);

        void compile(IStream& script);
        void exec() const;


        explicit operator PyObject*() const;
    };

}  // namespace Rt2::Python
