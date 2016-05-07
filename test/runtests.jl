using JuliaPerformanceVerification
using Base.Test

# write your own tests here
@test 1 == 1


iteration_cnt_range = [ 10^i for i in 1:7 ]
vector_size_range   = [ 10^i for i in 1:7 ]
vector_wins = trues(length(vector_size_range), length(iteration_cnt_range))
vector_faster = zeros(length(vector_size_range), length(iteration_cnt_range))
for (i, current_vector_size) in enumerate(vector_size_range), (j, iteration_cnt) in enumerate(iteration_cnt_range)
	a = rand(current_vector_size)
	b = rand(current_vector_size)
	c_vec = zeros(current_vector_size)
	c_iter = zeros(current_vector_size)
	tic()
	vecaddbyvec!(a, b, c_vec, iteration_cnt)
	vector_time = toq();
	tic()
	vecaddbyiter!(a, b, c_iter, iteration_cnt)
	iteration_time = toq();
	@test c_vec == c_iter
	vector_wins[i, j] = iteration_time > vector_time ? true: false
	vector_faster[i, j] = iteration_time / vector_time
	if vector_wins[i, j]
		@printf "Two %d dim vectors adding for %d times, vector add wins %.03f faster!\n" current_vector_size iteration_cnt vector_faster[i, j]
	else
		@printf "Two %d dim vectors adding for %d times, iteration add wins %.03f faster!\n" current_vector_size iteration_cnt 1/vector_faster[i, j]
	end
end

@printf "The vector add wins:\n %s \n" vector_wins
@printf "The vector add is x times fast as iteration:\n %s \n" vector_faster
