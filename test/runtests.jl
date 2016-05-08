using JuliaPerformanceVerification
using Base.Test

# write your own tests here
@test 1 == 1


iteration_cnt_range = [ 10^i for i in 1:7 ]
vector_size_range   = [ 10^i for i in 1:7 ]
vector_wins = trues(length(vector_size_range), length(iteration_cnt_range))
vector_faster = zeros(length(vector_size_range), length(iteration_cnt_range))
for (i, current_vector_size) in enumerate(vector_size_range), (j, iteration_cnt) in enumerate(iteration_cnt_range)
	if current_vector_size * iteration_cnt >= 10^10
	    continue
	end
	a = rand(current_vector_size)
	b = rand(current_vector_size)
	c_vec = zeros(current_vector_size)
	c_iter = zeros(current_vector_size)
	c_vec_oped = zeros(current_vector_size)
	c_iter_oped = zeros(current_vector_size)
	tic()
	vecaddbyvec!(a, b, c_vec, iteration_cnt)
	vector_time = toq();
	tic()
	vecaddbyiter!(a, b, c_iter, iteration_cnt)
	iteration_time = toq();
	@test c_vec == c_iter
	tic()
	vecaddbyvec_oped!(a, b, c_vec_oped, iteration_cnt)
	vector_oped_time = toq();
	tic()
	vecaddbyiter_oped!(a, b, c_iter_oped, iteration_cnt)
	iteration_oped_time = toq();
	@test c_vec == c_iter
	@test c_vec_oped == c_iter
	@test c_vec == c_iter_oped
	vector_wins[i, j] = iteration_time > vector_time ? true: false
	vector_faster[i, j] = iteration_time / vector_time
	if vector_wins[i, j]
		@printf "Two %d dim vectors adding for %d times, vector add wins %.03f faster!\n" current_vector_size iteration_cnt vector_faster[i, j]
	else
		@printf "Two %d dim vectors adding for %d times, iteration add wins %.03f faster!\n" current_vector_size iteration_cnt 1/vector_faster[i, j]
	end
	@printf "  @inbounds and @simd accelerate ratio Vector: %.03f; Iteration: %.03f\n\n" vector_time/vector_oped_time iteration_time/iteration_oped_time
end

@printf "The vector add wins:\n %s \n" vector_wins
@printf "The vector add is x times fast as iteration:\n %s \n" vector_faster
