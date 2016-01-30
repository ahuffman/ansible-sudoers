def to_list(a, *args, **kw):
    if (isinstance(a, list)):
        return a
    else:
        return [a]

class FilterModule(object):
    def filters(self):
        return {
            'to_list': to_list
        }
