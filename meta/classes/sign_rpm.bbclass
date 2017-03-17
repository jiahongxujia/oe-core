# Class for generating signed RPM packages.
#
# Configuration variables used by this class:
# RPM_GPG_PASSPHRASE_FILE
#           Path to a file containing the passphrase of the signing key.
# RPM_GPG_NAME
#           Name of the key to sign with. May be key id or key name.
# GPG_BIN
#           Optional variable for specifying the gpg binary/wrapper to use for
#           signing.
# GPG_PATH
#           Optional variable for specifying the gnupg "home" directory:
#
inherit sanity

RPM_SIGN_PACKAGES='1'


python () {
    # Check RPM_GPG_NAME configuration
    if not d.getVar('RPM_GPG_NAME', True):
        raise_sanity_error("You need to define RPM_GPG_NAME in the config")

    # Set the expected location of the public key
    d.setVar('RPM_GPG_PUBKEY', os.path.join(d.getVar('STAGING_ETCDIR_NATIVE'),
                                            'RPM-GPG-PUBKEY'))

    # Set default GPG_PATH if it is not configured
    if not d.getVar('GPG_PATH', True):
        d.setVar('GPG_PATH', d.getVar('DEPLOY_DIR_IMAGE', True) + '/.gnupg')
}


def rpmsign_wrapper(d, files, passphrase, gpg_name=None):
    import pexpect

    # Find the correct rpm binary
    rpm_bin_path = d.getVar('STAGING_BINDIR_NATIVE', True) + '/rpm'
    cmd = rpm_bin_path + " --addsign --define '_gpg_name %s' " % gpg_name
    if d.getVar('GPG_BIN', True):
        cmd += "--define '__gpg %s' " % d.getVar('GPG_BIN', True)
    if d.getVar('GPG_PATH', True):
        cmd += "--define '_gpg_path %s' " % d.getVar('GPG_PATH', True)
    cmd += ' '.join(files)

    # Need to use pexpect for feeding the passphrase
    proc = pexpect.spawn(cmd)
    try:
        proc.expect_exact('Enter pass phrase:', timeout=15)
        proc.sendline(passphrase)
        proc.expect(pexpect.EOF, timeout=900)
        proc.close()
    except pexpect.TIMEOUT as err:
        bb.warn('rpmsign timeout: %s' % err)
        proc.terminate()
    else:
        if os.WEXITSTATUS(proc.status) or not os.WIFEXITED(proc.status):
            bb.warn('rpmsign failed: %s' % proc.before.strip())
    return proc.exitstatus


python sign_rpm () {
    import glob

    # RPM_GPG_PASSPHRASE_FILE is optional.
    # Set passphrase as empty if RPM_GPG_PASSPHRASE_FILE is not specified
    if not d.getVar("RPM_GPG_PASSPHRASE_FILE", True):
        rpm_gpg_passphrase = ''
    else:
        with open(d.getVar("RPM_GPG_PASSPHRASE_FILE", True)) as fobj:
            if fobj.readlines():
                rpm_gpg_passphrase = fobj.readlines()[0].rstrip('\n')
            else:
                rpm_gpg_passphrase = ''

    rpm_gpg_name = (d.getVar("RPM_GPG_NAME", True) or "")

    rpms = glob.glob(d.getVar('RPM_PKGWRITEDIR', True) + '/*')

    if rpmsign_wrapper(d, rpms, rpm_gpg_passphrase, rpm_gpg_name) != 0:
        raise bb.build.FuncFailed("RPM signing failed")
}

do_package_index[depends] += "signing-keys-native:do_export_public_keys"
sign_rpm[depends] += "signing-keys-native:do_export_public_keys"
