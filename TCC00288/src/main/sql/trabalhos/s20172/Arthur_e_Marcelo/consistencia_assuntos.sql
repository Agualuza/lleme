CREATE OR REPLACE FUNCTION consistencia_assunto() RETURNS TRIGGER AS 
DECLARE
	nome_tabela text;
BEGIN
	-- Se n�o alterou id, banco est� consistente
	IF (NEW.id_assunto <> OLD.id_assunto) THEN
		IF (tg_table_name = 'imdb.filme') THEN
			nome_tabela = 'filme';
		ELSIF ((tg_table_name = 'imdb.profissional') THEN
			nome_tabela = 'profissional';
		END IF;
		
		-- Verifica se o assunto est� criado com tipo correspondente
		IF NOT EXISTS(SELECT *
			      FROM imdb.assunto a INNER JOIN imdb.tipo_assunto t ON a.tipo = t.id
			      WHERE t.nome = text) THEN
			RAISE EXCEPTION 'Inser��o incorreta, id de assunto n�o corresponde ao tipo pretendido';
		END IF;
	END IF;
END;
$$ LANGUAGE plpgsql 

CREATE TRIGGER consistencia_assuntoFilme AFTER INSERT OR UPDATE ON imdb.filme
	FOR EACH ROW EXECUTE PROCEDURE consistencia_assunto();

CREATE TRIGGER consistencia_assuntoProfissional AFTER INSERT OR UPDATE ON imdb.profissional
	FOR EACH ROW EXECUTE PROCEDURE consistencia_assunto();
		 	
		
