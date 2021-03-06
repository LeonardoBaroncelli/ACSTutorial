# Tutorial 2
The goal of this tutorial is to have a component "Console" communicating with a component "Telescope".  
```bash
cd TUTORIAL_2
. load_env.sh
```
## IDL Telescope Component
Let's create the IDL interface for the Telescope.
```bash
cd WORKSPACE
getTemplateForDirectory MODROOT_WS idlTelescope
cd idlTelescope
touch idl/Telescope.idl
```
Nothing new from the previous tutorial but some new simple IDL methods for the Telescope component.

**Makefile:**
```makefile
...
IDL_FILES = Telescope
TelescopeStubs_LIBS = acscomponentStubs
...
COMPONENT_HELPERS=on
```
Nothing new from the previous tutorial.

**Compilation:**
```bash
cd src/
make clean all install
```
### C++ implementation
```bash
cd WORKSPACE
getTemplateForDirectory MODROOT_WS cppTelescope
cd cppTelescope
touch include/TelescopeImpl.h
touch src/TelescopeImpl.cpp
```
Some private class attributes have been defined within the header file. 

**Makefile:**
```makefile
...
INCLUDES            = TelescopeImpl.h
LIBRARIES           = TelescopeImpl
TelescopeImpl_OBJECTS = TelescopeImpl
TelescopeImpl_LIBS    = TelescopeStubs acscomponent
...
```
**Compilation:**
```bash
cd src/
make clean all install
```
### JAVA implementation
```bash
cd WORKSPACE
getTemplateForDirectory MODROOT_WS jTelescope
cd jTelescope
mkdir -p src/<pragma-prefix>/<idl-module-name>/TelescopeImpl/
cp ../../idlTelescope/src/<pragma-prefix>/<idl-module-name>/TelescopeImpl/TelescopeComponentHelper.java.tpl <pragma-prefix>/<idl-module-name>/TelescopeImpl/TelescopeComponentHelper.java
touch src/<pragma-prefix>/<idl-module-name>/TelescopeImpl/TelescopeImpl.java
```
**Makefile:**
```makefile
...
JARFILES = TelescopeImpl
TelescopeImpl_DIRS = <pragma-prefix>
...
```
**Compilation:**
```bash
cd src/
make clean all install
```

### Python implementation
```bash
cd WORKSPACE
getTemplateForDirectory MODROOT_WS pyTelescope
cd pyTelescope
mkdir src/acstut
touch src/acstut/__init__.py
touch src/acstut/TelescopeImpl.py
```
**Makefile:**
```makefile
...
PY_PACKAGES        = acstut
...
```
**Compilation:**
```bash
cd src/
make clean all install
```


## IDL Console Component
Let's create the interface of the Console component that will call the Telescope's methods.
```bash
cd WORKSPACE
getTemplateForDirectory MODROOT_WS idlConsole
cd idlConsole
touch idl/Console.idl
```
Still nothing new in the IDL, just two new simple interface methods.

**Makefile:**
```makefile
...
IDL_FILES = Console
HelloComponentStubs_LIBS = acscomponentStubs
...
COMPONENT_HELPERS=on
```
**Compilation:**
```bash
cd src/
make clean all install
```

### C++ implementation
```bash
cd WORKSPACE
getTemplateForDirectory MODROOT_WS cppConsole
cd cppConsole
touch include/ConsoleImpl.h
touch src/ConsoleImpl.cpp
```
Note that include/ConsoleImpl.h must be include the Telescope client interface:

**include/ConsoleImpl.h:**
```cpp
#include <TelescopeC.h>
```
The Console component can acquire a reference of the Telescope component using the following signature:

**src/ConsoleImpl.cpp:**
```cpp
acstutorial::Telescope_var telescope_component = this->getContainerServices()->getComponent<acstutorial::Telescope>("CPP_TELESCOPE");
```
Let's explain the signature:
* "acstutorial" is the name of the Telescope IDL module (converted into a namespace).
* "Telescope_var": <interface>_var is an ACS predefined type representing a smart pointer. The pointer must be released with releaseComponent() (see later).
* "CPP_TELESCOPE" is the component name, defined within the MACI/Components.xml configuration

The pointer must be released with:

**include/ConsoleImpl.h:**
```cpp
this->getContainerServices()->releaseComponent(telescope_component->name());
```

**Makefile:**
```makefile
...
INCLUDES            = ConsoleImpl.h
LIBRARIES           = ConsoleImpl
ConsoleImpl_OBJECTS = ConsoleImpl
ConsoleImpl_LIBS    = ConsoleStubs acscomponent TelescopeStubs maci
...
```
Since we are including the Telescope client implementation we need to link the corresponding library. In addition, since we call the "getContainerServices()" and "getComponent()" methods we need to link the "libmaci".

**Compilation:**
```bash
cd src/
make clean all install
```
### JAVA implementation
```bash
cd WORKSPACE
getTemplateForDirectory MODROOT_WS jConsole
cd jConsole
mkdir -p src/<pragma-prefix>/<idl-module-name>/ConsoleImpl/
cp ../../idlConsole/src/<pragma-prefix>/<idl-module-name>/ConsoleImpl/ConsoleComponentHelper.java.tpl <pragma-prefix>/<idl-module-name>/ConsoleImpl/ConsoleComponentHelper.java
touch src/<pragma-prefix>/<idl-module-name>/ConsoleImpl/ConsoleImpl.java
```
**Makefile:**
```makefile
...
JARFILES = ConsoleImpl
ConsoleImpl_DIRS = <pragma-prefix>
...
```
**Compilation:**
```bash
cd src/
make clean all install
```

### Python implementation
```bash
cd WORKSPACE
getTemplateForDirectory MODROOT_WS pyConsole
cd pyConsole
mkdir src/acstut
touch src/acstut/__init__.py
touch src/acstut/ConsoleImpl.py
```
Makefile:
```makefile
...
PY_PACKAGES        = acstut
...
```
Compilation:
```bash
cd src/
make clean all install
```

## MACI
CDB/MACI/Components/Components.xml
```xml
  <e Name="CPP_CONSOLE"
     Code="ConsoleImpl"
     Type="IDL:acsws/acstutorial/Console:1.0"
     Container="bilboContainer"
     ImplLang="cpp"/>

  <e Name="PY_CONSOLE"
     Code="acstut.ConsoleImpl"
     Type="IDL:acsws/acstutorial/Console:1.0"
     Container="aragornContainer"
     ImplLang="py"/>

  <e Name="CPP_TELESCOPE"
     Code="TelescopeImpl"
     Type="IDL:acsws/acstutorial/Telescope:1.0"
     Container="bilboContainer"
     ImplLang="cpp"/>

   <e Name="J_TELESCOPE"
      Code="acsws.acstutorial.TelescopeImpl.TelescopeComponentHelper"
      Type="IDL:acsws/acstutorial/Telescope:1.0"
      Container="frodoContainer"
      ImplLang="java"/>

   <e Name="J_CONSOLE"
      Code="acsws.acstutorial.ConsoleImpl.ConsoleComponentHelper"
      Type="IDL:acsws/acstutorial/Console:1.0"
      Container="frodoContainer"
      ImplLang="java"/>

  <e Name="PY_TELESCOPE"
     Code="acstut.TelescopeImpl"
     Type="IDL:acsws/acstutorial/Telescope:1.0"
     Container="aragornContainer"
     ImplLang="py"/>

```

