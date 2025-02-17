{
  description = "Flake project templates";

  outputs =
    { self }:
    {
      templates = {
        python-venv = {
          path = ./python-venv;
          description = "Python development template using venv";
          welcomeText = ''
            Creating a new Python project using venv
          '';
        };
        python-uv = {
          python = ./python-uv;
          description = "Python development template using uv";
          welcomeText = ''
            # Getting started
            - run `direnv allow`
          '';
        };
      };
    };
}
