module JuliaPerformanceVerification

# package code goes here

export vecaddbyvec!, vecaddbyiter!

function vecaddbyvec!(a, b, c, N)
	for i = 1:N
		c[:] = a + b
	end
end

function vecaddbyiter!(a, b, c, N)
	for i = 1:N, j = 1:length(a)
		c[j] = a[j] + b[j]
	end
end

end # module
