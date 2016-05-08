module JuliaPerformanceVerification

# package code goes here

export vecaddbyvec!, vecaddbyiter!, vecaddbyvec_oped!, vecaddbyiter_oped!

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

function vecaddbyvec_oped!(a, b, c, N)
	@simd for i = 1:N
		@inbounds c[:] = a + b
	end
end

function vecaddbyiter_oped!(a, b, c, N)
	for i = 1:N
		@simd for j = 1:length(a)
			@inbounds c[j] = a[j] + b[j]
		end
	end
end

end # module
