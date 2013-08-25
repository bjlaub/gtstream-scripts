import sys
import random
import optparse
import httplib
import time

def gen_log_entry(outf):
    x = random.lognormvariate(0, 1)
    if x < 2:
        response = 200
    elif x < 3:
        response = 404
    else:
        response = random.choice(httplib.responses.keys())

    host = "127.0.0.1"
    timestamp = time.strftime("%d/%b/%Y %H:%M:%S")
    resource = "/index.html"
    method = "GET"

    logstr = "%(host)s - - [%(timestamp)s] \"%(method)s %(resource)s HTTP/1.1\" %(response)d\n" % locals()
    outf.write(logstr)


def gen_workload(outfile, rate):
    sleep_duration = 1.0 / float(rate)
    while True:
        gen_log_entry(outfile)
        time.sleep(sleep_duration)


def main(argv):
    parser = optparse.OptionParser()
    parser.add_option('-r', '--rate', type='float', metavar='N',
        help='generate N log messages per second')
    parser.add_option('-o', '--outfile', metavar='FILE',
        help='write log messages to FILE [default=stdout]')

    opts, args = parser.parse_args(argv)
    if not opts.rate:
        print "option --rate is required"
        parser.print_help()
        sys.exit(1)

    if opts.outfile:
        with open(opts.outfile, 'a') as f:
            gen_workload(f, opts.rate)
    else:
        gen_workload(sys.stdout, opts.rate)


if __name__ == '__main__':
    main(sys.argv[1:])


