-- Schema do banco de dados para MooveTag
-- Execute este SQL no editor SQL do Supabase

-- Tabela de grupos de tags
CREATE TABLE IF NOT EXISTS groups (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de tags NFC
CREATE TABLE IF NOT EXISTS tags (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    tag_id VARCHAR(255) NOT NULL, -- ID físico da tag NFC
    name VARCHAR(255) NOT NULL,
    description TEXT,
    location TEXT,
    group_id UUID REFERENCES groups(id) ON DELETE SET NULL,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    last_scanned TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(tag_id, user_id) -- Uma tag física pode pertencer apenas a um usuário
);

-- Tabela de histórico de leituras das tags
CREATE TABLE IF NOT EXISTS tag_readings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    tag_id VARCHAR(255) NOT NULL, -- Referência ao ID físico da tag
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    location TEXT,
    metadata JSONB, -- Dados adicionais da leitura
    read_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para melhorar performance
CREATE INDEX IF NOT EXISTS idx_groups_user_id ON groups(user_id);
CREATE INDEX IF NOT EXISTS idx_groups_created_at ON groups(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_tags_user_id ON tags(user_id);
CREATE INDEX IF NOT EXISTS idx_tags_group_id ON tags(group_id);
CREATE INDEX IF NOT EXISTS idx_tags_tag_id ON tags(tag_id);
CREATE INDEX IF NOT EXISTS idx_tags_created_at ON tags(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_tag_readings_user_id ON tag_readings(user_id);
CREATE INDEX IF NOT EXISTS idx_tag_readings_tag_id ON tag_readings(tag_id);
CREATE INDEX IF NOT EXISTS idx_tag_readings_read_at ON tag_readings(read_at DESC);

-- Triggers para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Aplicar triggers
DROP TRIGGER IF EXISTS update_groups_updated_at ON groups;
CREATE TRIGGER update_groups_updated_at
    BEFORE UPDATE ON groups
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_tags_updated_at ON tags;
CREATE TRIGGER update_tags_updated_at
    BEFORE UPDATE ON tags
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Row Level Security (RLS) - Segurança a nível de linha
ALTER TABLE groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE tag_readings ENABLE ROW LEVEL SECURITY;

-- Políticas de segurança para groups
CREATE POLICY "Users can view own groups" ON groups
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own groups" ON groups
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own groups" ON groups
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own groups" ON groups
    FOR DELETE USING (auth.uid() = user_id);

-- Políticas de segurança para tags
CREATE POLICY "Users can view own tags" ON tags
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own tags" ON tags
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own tags" ON tags
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own tags" ON tags
    FOR DELETE USING (auth.uid() = user_id);

-- Políticas de segurança para tag_readings
CREATE POLICY "Users can view own tag readings" ON tag_readings
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own tag readings" ON tag_readings
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own tag readings" ON tag_readings
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own tag readings" ON tag_readings
    FOR DELETE USING (auth.uid() = user_id);

-- Função para obter estatísticas do usuário
CREATE OR REPLACE FUNCTION get_user_stats(p_user_id UUID)
RETURNS JSON AS $$
DECLARE
    total_groups INTEGER;
    total_tags INTEGER;
    readings_last_month INTEGER;
BEGIN
    -- Contar grupos
    SELECT COUNT(*) INTO total_groups 
    FROM groups 
    WHERE user_id = p_user_id;
    
    -- Contar tags
    SELECT COUNT(*) INTO total_tags 
    FROM tags 
    WHERE user_id = p_user_id;
    
    -- Contar leituras do último mês
    SELECT COUNT(*) INTO readings_last_month 
    FROM tag_readings 
    WHERE user_id = p_user_id 
    AND read_at >= NOW() - INTERVAL '30 days';
    
    RETURN JSON_BUILD_OBJECT(
        'total_groups', total_groups,
        'total_tags', total_tags,
        'readings_last_month', readings_last_month
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Comentários explicativos
COMMENT ON TABLE groups IS 'Grupos de tags NFC organizados pelo usuário';
COMMENT ON TABLE tags IS 'Tags NFC cadastradas com suas informações';
COMMENT ON TABLE tag_readings IS 'Histórico de leituras das tags NFC';

COMMENT ON COLUMN tags.tag_id IS 'ID físico único da tag NFC (NDEF ID)';
COMMENT ON COLUMN tags.last_scanned IS 'Último momento que a tag foi escaneada';
COMMENT ON COLUMN tag_readings.metadata IS 'Dados adicionais da leitura em formato JSON';
