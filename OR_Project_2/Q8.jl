using JuMP
using GLPK

struct Activity
    start::Int32
    finish::Int32
end

activities = [Activity(480,555), Activity(540,720),Activity(555,660),Activity(630,800),
			  Activity(600,645),Activity(645,720),Activity(690,810), Activity(750,840),
			  Activity(795,900), Activity(825,855),Activity(870,900),Activity(840,960),
			  Activity(840,870),Activity(930,1020),Activity(960,1020)]
n = length(activities)
m = Model(GLPK.Optimizer)

@variable(m, x[activities], Bin)
@objective(m, Max, sum(x[a] for a in activities))

for i=1:n-1
	for j=i+1:n
		ai = activities[i]
		aj = activities[j]
		if(!(ai.finish <= aj.start || aj.finish <= ai.start))
			@constraint(m, x[ai]+x[aj]<=1)
		end
	end
end

optimize!(m)
println("Objective Value: ", objective_value(m))
println("Variable values: ", JuMP.value.(x))
