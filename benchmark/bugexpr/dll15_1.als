all n1, n2: DLL.header.*nxt | n1 != n2 implies ((n1.nxt = n2 implies n2.pre = n1) and (n1.pre = n2 implies n2.nxt = n1))