{ self, inputs, ... }: {

  perSystem = { pkgs, ... }: {
    packages.git = inputs.wrapper-modules.wrappers.git.wrap {
      inherit pkgs;

      package = pkgs.git;

      env = rec {
        GIT_AUTHOR_NAME = "Debugger Doctor";
        GIT_AUTHOR_EMAIL = "doctor.cybersec122@gmail.com";
        GIT_COMMITTER_NAME = GIT_AUTHOR_NAME;
        GIT_COMMITTER_EMAIL = GIT_AUTHOR_EMAIL;
      };
    };
  };

}
