
set SERVEROUTPUT ON
declare
cursor c_custo is 
    select d.cd_depto,
       d.nm_depto,
       sum(vl_salario) vl_salario_mes,
       sum(12*vl_salario) vl_salario_ano
    from loc_funcionario a 
        join loc_depto d on d.CD_DEPTO = a.CD_DEPTO
        group by 
            d.cd_depto, 
            d.nm_depto;    
    
    v_custo  c_custo%rowtype;
begin 
    open c_custo;
    loop
        fetch c_custo into v_custo;
        exit when c_custo%notfound;
        begin
            insert into custos_depto values (
                       v_custo.cd_depto,
                       v_custo.nm_depto,
                       v_custo.vl_salario_mes,
                       v_custo.vl_salario_ano,
                       sysdate
                       );
          dbms_output.put_line('O departamento ' || v_custo.nm_depto || ' foi inserido com sucesso!');      
                exception when dup_val_on_index then
                    update custos_depto 
                        set vl_salario_mes = v_custo.vl_salario_mes,
                              vl_salario_ano = v_custo.vl_salario_ano 
                    		where id_depto = v_custo.cd_depto;
            dbms_output.put_line('O registro numero: ' || v_custo.cd_depto || ' foi atualizado!' );
                 
        end;
    end loop;
    close c_custo;

end;
