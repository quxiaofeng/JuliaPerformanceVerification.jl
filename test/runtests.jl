using JuliaPerformanceVerification
using Base.Test

# write your own tests here
@test 1 == 1


iteration_cnt_range = [ 10^i for i in 1:10 ]
vector_size_range   = [ 10^i for i in 1:10 ]
vector_wins = trues(length(vector_size_range), length(iteration_cnt_range))
for (i, current_vector_size) in enumerate(vector_size_range), (j, iteration_cnt) in enumerate(iteration_cnt_range)
	a = rand(current_vector_size)
	b = rand(current_vector_size)
	c = zeros(current_vector_size)
	tic()
	vecaddbyvec(a, b, c, iteration_cnt)
	vector_time = toq();
	tic()
	vecaddbyiter(a, b, c, iteration_cnt)
	iteration_time = toq();
	vector_wins[i, j] = iteration_time > vector_time ? true: false
	if vector_wins[i, j]
		@printf "For two %d vectors to add for %d times, vector add wins!" current_vector_size iteration_cnt
	else
		@printf "For two %d vectors to add for %d times, iteration add wins!" current_vector_size iteration_cnt
	end
end
@printf "%s" a
