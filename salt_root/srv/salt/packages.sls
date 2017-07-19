common packages installed:
  pkg.latest:
    # FIXME Refresh takes too much time. Only reasonable way is to use salt
    # schedule to refresh nightly.
    #- refresh: True
    - pkgs:
      - htop
      - vim
      - fish
