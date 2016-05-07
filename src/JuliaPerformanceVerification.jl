module JuliaPerformanceVerification

# package code goes here

export vecaddbyvec, vecaddbyiter

function vecaddbyvec(a, b, c, N)
	for i in 1:N
		c = a + b
	end
end

function vecaddbyiter(a, b, c, N)
	for i in 1:N, j in 1:length(a)
		c[j] = a[j] + b[j]
	end
end

end # module
