proftpd:
  settings:
    common:
      - name: COMMON
        DefaultServer: 'on'
        DeferWelcome: 'on'
        IdentLookups: 'off'
        MultilineRFC2228: 'on'
        Port: 21
...

        User: proftpd
        Group: nogroup

      - name: RESOURCE LIMITATIONS
        MaxClients: 100
...

      - name: ACCESS CONTROL
        AllowOverwrite: 'on'
        AllowRetrieveRestart: 'on'
        AllowStoreRestart: 'on'
        DefaultRoot: '~'
        DenyFilter: \*.*/
...

      - name: LOGS
        sect_append: |
          SystemLog /var/log/proftpd/proftpd.log
          TransferLog /var/log/proftpd/xferlog
...

      - name: AUTH
        AuthUserFile: /etc/proftpd/passwd
...

      - name: CONTROLS
        ControlsEngine: 'off'
        ControlsInterval: 5
        ControlsLog: /var/log/proftpd/controls.log
        ControlsMaxClients: 2
        ControlsSocket: /var/run/proftpd/proftpd.sock
        sect_append: |
          ModuleControlsACLs insmod,rmmod allow user root
          ModuleControlsACLs lsmod allow user *
    tls:
      - name: TRANSPORT SECURITY
        LoadModule: mod_tls.c
...
    modules:
      - name: MODULES
        ModulePath: /usr/lib/proftpd
