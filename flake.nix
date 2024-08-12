{
  description = "Flake project templates";

  outputs = {...}: {
    templates = {
      python-venv = {
        path = ./python-venv;
        description = "Python development template using venv";
        welcomeText = ''
          Creating a new Python project using venv
        '';
      };
    };
  };
}
