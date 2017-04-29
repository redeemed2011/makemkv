"""Test integer/numeric environment variable options."""

import pytest


@pytest.mark.parametrize('gid', [-1, 0, 1000, 1234])
@pytest.mark.parametrize('uid', [-1, 0, 1000, 1234])
@pytest.mark.usefixtures('cdemu')
def test_ownership(tmpdir, gid, uid):
    """Test user and group IDs of directories and MKV files. 1000 is the default ID in the container.

    :param py.path.local tmpdir: pytest fixture.
    :param int gid: Set MKV_GID to this if not -1, otherwise don't set.
    :param int uid: Set MKV_UID to this if not -1, otherwise don't set.
    """
    output = tmpdir.ensure_dir('output')
    args = list()
    if gid >= 0:
        args += ['-e', 'MKV_GID={}'.format(gid)]
    if uid >= 0:
        args += ['-e', 'MKV_UID={}'.format(uid)]

    # Docker run.
    pytest.run(args=args, output=output)

    # Verify.
    pytest.verify(output, gid=1234 if gid == 1234 else 1000, uid=1234 if uid == 1234 else 1000)
