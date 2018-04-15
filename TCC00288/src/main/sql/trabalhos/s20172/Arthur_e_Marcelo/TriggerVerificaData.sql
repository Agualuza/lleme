CREATE OR REPLACE FUNCTION checa_data() RETURNS TRIGGER AS 
$$
DECLARE
	lancamento timestamp;
BEGIN
	-- Verifica se o usu�rio cuja critica foi inserida ou sofreu altera��o n�o � usu�rio padr�o
	IF EXISTS (SELECT *
		   FROM imdb.usuario u INNER JOIN imdb.tipo_usuario t ON u.tipo = t.id
	           WHERE u.id = NEW.id AND t.nome <> 'Padr�o') THEN
	RETURN NEW;

	-- Caso seja padr�o, � necess�rio checar a data da cr�tica em rela��o a estreia do filme
	ELSE	
		SELECT (f.dataEstreia) INTO lancamento
		FROM imdb.filme f
		WHERE f.id_assunto = NEW.id_Filme;
		
		-- Se a cr�tica � de antes da estreia do filme e usu�rio � padr�o, n�o pode alterar
		IF (now() < lancamento) THEN
			RAISE EXCEPTION 'Usu�rio padr�o s� pode possuir cr�tica dom data ap�s estr�ia do filme';
		ELSE 
			RETURN NEW;
		END IF;
	END IF;
END;
$$ LANGUAGE plpgsql;
				

CREATE TRIGGER checa_dataTrig BEFORE INSERT OR UPDATE ON imdb.critica 
	FOR EACH ROW EXECUTE PROCEDURE checa_data();