import sys

sys.argv.remove(sys.argv[0])

def execCmd(cmd):
    import subprocess
    p = subprocess.Popen(cmd, stdin=subprocess.PIPE,
                         stderr=subprocess.PIPE,
                         stdout=subprocess.PIPE
                         )
    stdout, stderr = p.communicate()

    return stdout, stderr

stdout, stderr = execCmd(sys.argv)
print("stdout:"+stdout.decode("UTF-8")+"stderr:"+stderr.decode("UTF-8"))