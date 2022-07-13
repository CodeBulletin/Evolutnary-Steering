ArrayList<Prey> Agents;
ArrayList<Predators> Agents2;
ArrayList<PVector> food, poison;
static final int Perf_Factor = 4;
//Some toggles
boolean debug = false;
boolean fastMode = false;
//initial conditions
int Amount_of_food = 1600;
int Amount_of_poison = 400;
int Starting_world_population = 200;
int Predator_pop = 15;
//World properties
int StartingHealth = 1000;
int healthLimit = 1500;
int foodvalue = 300;
int poisonvalue = 600;
int sex_cost = 300;
int asex_cost = 100;
int Min_foodRequired_forReproduction = 300;
int health_redu = 5;
float Small_mutation_percentage = 0.95;
float mutation = 0.1;
float Sexual_Reproduction_chances = 0.1;
float Asexual_Reproduction_chances = 0.001;
float sex_regain = 0.001;
float foodAdd = 0.8;
float PoisonAdd = 0.1;
//Prey and Predator setting
float size_of_bodies = 9;
float MaxSpeed = 8;
float MaxSpeedP = 5;
float MaxAcc = 0.8;
float MaxAccP = 0.5;
float Predator_eye = 350;
float Predator_repl = 150;
float eye_limit = 300;
float forceMul = 5;
