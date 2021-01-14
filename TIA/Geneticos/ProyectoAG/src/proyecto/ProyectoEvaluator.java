package proyecto;

import java.util.ArrayList;
import java.util.Arrays;

import org.opt4j.core.Objective.Sign;
import org.opt4j.core.Objectives;
import org.opt4j.core.problem.Evaluator;

public class ProyectoEvaluator implements Evaluator<ArrayList<Integer>>
{
	public boolean contiene(final int[] array, final int valor) {
	    for (final int i : array) {
	        if (i == valor) {
	            return true;
	        }
	    }
	    return false;
	}
	
	@Override
	public Objectives evaluate(ArrayList<Integer> fenotipo) {
		
		int costeTotal= 0;
		int voluntarios = 0;
		int vacuna;
		int vacunaAplicada[] = new int[DatosVacunas.NUM_GRUPOS];
		//ArrayList<Integer> vacunaAplicada = new ArrayList<Integer>();
		int vacJoven[] = new int[4];
		int vacAdult[] = new int[4];
		int vacMay[] = new int[5];
		for(int i = 0; i < fenotipo.size(); i++) {
			vacuna = fenotipo.get(i);
			costeTotal += DatosVacunas.matrizCostes[vacuna- 1][i];
			vacunaAplicada[i] = vacuna;
			if(vacuna != 3 && vacuna !=4)
			{
				voluntarios += DatosVacunas.numeroVoluntarios[i];
			}
		}

		System.arraycopy(vacunaAplicada, 0, vacJoven, 0, 4);
		System.arraycopy(vacunaAplicada, 4, vacAdult, 0, 4);
		System.arraycopy(vacunaAplicada, 8, vacMay, 0, 5);

	
		for (int j = 1; j <= 4; j++) {
			if (!contiene(vacJoven,j)) {
				costeTotal = Integer.MAX_VALUE;
				voluntarios = Integer.MIN_VALUE;
			}
			if (!contiene(vacAdult,j)) {
				costeTotal = Integer.MAX_VALUE;
				voluntarios = Integer.MIN_VALUE;
			}
			if (!contiene(vacMay,j)) {
				costeTotal = Integer.MAX_VALUE;
				voluntarios = Integer.MIN_VALUE;
			}
		}
		if (vacunaAplicada[3]!= 4) {
			costeTotal = Integer.MAX_VALUE;
			voluntarios = Integer.MIN_VALUE;
		}
		
		Objectives objetivo = new Objectives();

		
		objetivo.add("Coste-MAX", Sign.MAX, voluntarios);
		objetivo.add("Coste-MIN", Sign.MIN, costeTotal);
		return objetivo;
		
		
	}
	

}
